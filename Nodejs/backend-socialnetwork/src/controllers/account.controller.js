const Account = require('../models/account.model');
const { Post } = require('../models/content.model');
const bcrypt = require('bcrypt');

const getProfile = async (req, res) => {
    try {
        const user = await Account.findById(req.userId).select('-password').lean();
        if (!user) return res.status(404).json({ message: "User not found!" });

        const postCount = await Post.countDocuments({ author: req.userId });

        user.stats = {
            friendsCount: user.friends ? user.friends.length : 0,
            followersCount: user.followers ? user.followers.length : 0,
            followingCount: user.following ? user.following.length : 0,
            postCount: postCount
        };

        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const updateProfile = async (req, res) => {
    try {
        const { username, dob, gender, email, password, address, phone, job } = req.body;
        
        const updateData = {};
        if (username) updateData.username = username;
        if (dob) updateData.dob = dob;
        if (gender) updateData.gender = gender;
        if (email) updateData.email = email;
        if (address) updateData.address = address;
        if (phone) updateData.phone = phone;
        if (job) updateData.job = job;

        if (password) {
            updateData.password = await bcrypt.hash(password, 10);
        }

        if (req.file) {
            updateData.avatar = req.file.path;
        }

        const updatedUser = await Account.findByIdAndUpdate(req.userId, updateData, { new: true }).select('-password').lean();
        
        const postCount = await Post.countDocuments({ author: req.userId });

        updatedUser.stats = {
            friendsCount: updatedUser.friends ? updatedUser.friends.length : 0,
            followersCount: updatedUser.followers ? updatedUser.followers.length : 0,
            followingCount: updatedUser.following ? updatedUser.following.length : 0,
            postCount: postCount
        };

        res.status(200).json({ message: "Update successful!", user: updatedUser });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const searchUsers = async (req, res) => {
    try {
        const { q } = req.query;
        if (!q) {
            return res.status(400).json({ message: "Search query 'q' is required!" });
        }

        const users = await Account.find({
            username: { $regex: q, $options: 'i' }
        }).select('avatar username email dob gender address phone job friends followers following').lean();

        const usersWithStats = users.map(user => {
            const stats = {
                friendsCount: user.friends ? user.friends.length : 0,
                followersCount: user.followers ? user.followers.length : 0,
                followingCount: user.following ? user.following.length : 0
            };
            
            delete user.friends;
            delete user.followers;
            delete user.following;

            return { ...user, stats };
        });

        res.status(200).json(usersWithStats);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const getUserById = async (req, res) => {
    try {
        const { id } = req.params;
        const user = await Account.findById(id).select('-password').lean();
        if (!user) return res.status(404).json({ message: "User not found!" });

        const postCount = await Post.countDocuments({ author: id });

        return res.status(200).json({
            ...user,
            friendsCount: user.friends?.length ?? 0,
            followersCount: user.followers?.length ?? 0,
            followingCount: user.following?.length ?? 0,
            postCount,
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const saveFcmToken = async (req, res) => {
    try {
        const { fcmToken } = req.body;
        if (!fcmToken) {
            return res.status(400).json({ success: false, message: 'fcmToken is required' });
        }
        await Account.findByIdAndUpdate(req.userId, { fcmToken });
        res.json({ success: true, message: 'FCM token saved' });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const removeFcmToken = async (req, res) => {
    try {
        await Account.findByIdAndUpdate(req.userId, { fcmToken: null });
        res.json({ success: true, message: 'FCM token removed' });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const addPhone = async (req, res) => {
    try {
        const { phone } = req.body;
        await Account.findByIdAndUpdate(req.userId, { $set: { phone } });
        return res.json({ 
            success: true,
            code: 'PHONE_ADDED_SUCCESS' 
        });
    } catch (error) {
        return res.status(500).json({ 
            success: false, 
            code: 'SERVER_ERROR' 
        });
    }
};

const addAddress = async (req, res) => {
    try {
        const { address } = req.body;
        await Account.findByIdAndUpdate(req.userId, { $set: { address } });
        return res.json({ 
            success: true,
            code: 'ADDRESS_ADD_SUCCESS' 
        });
    } catch (error) {
        return res.status(500).json({ 
            success: false, 
            code: 'SERVER_ERROR' 
        });
    }
};

const addJob = async (req, res) => {
    try {
        const { job } = req.body;

        await Account.findByIdAndUpdate(req.userId, { $set: { job } });

        return res.json({ 
            success: true,
            code: 'Job_ADD_SUCCESS' 
        });

    } catch (error) {
        return res.status(500).json({ 
            success: false, 
            code: 'SERVER_ERROR' 
        });
    }
};

const addNationality = async (req, res) => {
    try {
        const { nationality } = req.body;

        await Account.findByIdAndUpdate(req.userId, { $set: { nationality } });

        return res.json({ 
            success: true,
            code: 'NATIONALITY_ADD_SUCCESS' 
        });

    } catch (error) {
        return res.status(500).json({ 
            success: false, 
            code: 'SERVER_ERROR' 
        });
    }
};

module.exports = { 
    getProfile, 
    updateProfile, 
    searchUsers, 
    getUserById, 
    saveFcmToken, 
    removeFcmToken,
    addPhone,
    addAddress,
    addJob,
    addNationality
};