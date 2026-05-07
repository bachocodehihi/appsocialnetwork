const { Post, Comment } = require('../models/content.model');

const createPost = async (req, res) => {
    try {
        const { content } = req.body;
        
        const images = [];
        if (req.files && req.files.length > 0) {
            req.files.forEach(file => {
                images.push(file.path);
            });
        }

        const newPost = new Post({
            author: req.userId,
            content,
            images
        });

        await newPost.save();
        res.status(201).json({ message: "Post created successfully!", post: newPost });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const likePost = async (req, res) => {
    try {
        const post = await Post.findById(req.params.id);
        if (!post) return res.status(404).json({ message: "Post not found!" });

        if (post.likes.includes(req.userId)) {
            post.likes.pull(req.userId);
            await post.save();
            return res.status(200).json({ message: "Unliked the post!", post });
        } else {
            post.likes.push(req.userId);
            await post.save();
            return res.status(200).json({ message: "Liked the post!", post });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const commentPost = async (req, res) => {
    try {
        const { content } = req.body;
        const postId = req.params.id;

        const post = await Post.findById(postId);
        if (!post) return res.status(404).json({ message: "Post not found!" });

        const newComment = new Comment({
            author: req.userId,
            post: postId,
            content
        });
        await newComment.save();

        post.comments.push(newComment._id);
        await post.save();

        res.status(201).json({ message: "Comment added successfully!", comment: newComment });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = { createPost, likePost, commentPost };
