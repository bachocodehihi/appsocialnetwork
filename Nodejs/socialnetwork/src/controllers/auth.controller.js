const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const QRCode = require('qrcode');
const Account = require('../models/account.model');
const OTP = require('../models/otp.model');
const { Post } = require('../models/content.model');
const { sendOTP } = require('../services/email.service');
const { cloudinary } = require('../config/cloudinary');

const sendOtp = async (req, res) => {
    try {
        const { email } = req.body;

        const existingUser = await Account.findOne({ email });
        if (existingUser) return res.status(400).json({ message: "Email already in use!" });

        await OTP.deleteMany({ email });

        const otpCode = Math.floor(100000 + Math.random() * 900000).toString();

        const newOTP = new OTP({ email, otp: otpCode });
        await newOTP.save();

        await sendOTP(email, otpCode);

        res.status(200).json({ message: "OTP code has been sent to your email. Please check.", email });

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const verifyOtp = async (req, res) => {
    try {
        const { email, otp } = req.body;
        const otpRecord = await OTP.findOne({ email, otp });

        if (!otpRecord) return res.status(400).json({ message: "Invalid or expired OTP!" });

        const now = new Date();
        if (now.getTime() - otpRecord.otpTime.getTime() > 60 * 1000) {
            await OTP.deleteOne({ _id: otpRecord._id });
            return res.status(400).json({ message: "OTP has expired!" });
        }

        otpRecord.isVerified = true;
        await otpRecord.save();

        res.status(200).json({ message: "OTP verification successful! Please fill in registration details." });

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const register = async (req, res) => {
    try {
        const { email, username, password, dob, gender, avatar: avatarBase64 } = req.body;

        const otpRecord = await OTP.findOne({ email, isVerified: true });
        if (!otpRecord) return res.status(400).json({ message: "Email not verified or invalid!" });

        const existingUser = await Account.findOne({ email });
        if (existingUser) return res.status(400).json({ message: "This email is already in use!" });

        const hashedPassword = await bcrypt.hash(password, 10);

        let finalAvatar = process.env.DEFAULT_AVATAR_URL;

        if (avatarBase64) {
            let uploadStr = avatarBase64;
            if (!uploadStr.startsWith('data:image')) {
                uploadStr = `data:image/jpeg;base64,${uploadStr}`;
            }
            const uploadResponse = await cloudinary.uploader.upload(uploadStr, {
                folder: 'socialnetwork'
            });
            finalAvatar = uploadResponse.secure_url;
        } else if (req.file) {
            finalAvatar = req.file.path;
        }

        const newUser = new Account({
            email,
            username,
            password: hashedPassword,
            dob,
            gender,
            avatar: finalAvatar,
            isVerified: true
        });

        const savedUser = await newUser.save();

        const qrDataUrl = await QRCode.toDataURL(savedUser._id.toString());

        const qrUploadResponse = await cloudinary.uploader.upload(qrDataUrl, {
            folder: 'socialnetwork/qrcodes'
        });

        savedUser.qrCode = qrUploadResponse.secure_url;
        await savedUser.save();

        await OTP.deleteMany({ email });

        res.status(201).json({ message: "Account created successfully!", user: savedUser });

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        const user = await Account.findOne({ email }).lean();
        if (!user) return res.status(400).json({ message: "Email not found!" });

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(400).json({ message: "Incorrect password!" });

        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '7d' });

        const postCount = await Post.countDocuments({ author: user._id });

        user.stats = {
            friendsCount: user.friends ? user.friends.length : 0,
            followersCount: user.followers ? user.followers.length : 0,
            followingCount: user.following ? user.following.length : 0,
            postCount: postCount
        };

        delete user.password;

        res.status(200).json({ message: "Login successful!", token, user });

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const checkEmail = async (req, res) => {
    try {
        const { email } = req.body;

        const user = await Account.findOne({ email });
        if (!user) {
            return res.status(404).json({ message: "Email does not exist!" });
        }

        return res.status(200).json({ message: "Valid email!" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = { sendOtp, checkEmail, register, verifyOtp, login };
