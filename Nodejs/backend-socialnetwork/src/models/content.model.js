const mongoose = require('mongoose');

const commentSchema = new mongoose.Schema({
    author: { type: mongoose.Schema.Types.ObjectId, ref: 'Account', required: true },
    post: { type: mongoose.Schema.Types.ObjectId, ref: 'Post', required: true },
    content: { type: String, required: true }
}, { timestamps: true });

const postSchema = new mongoose.Schema({
    author: { type: mongoose.Schema.Types.ObjectId, ref: 'Account', required: true },
    content: { type: String, required: true },
    images: [{ type: String }],
    likes: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Account' }],
    comments: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Comment' }]
}, { timestamps: true });

const Post = mongoose.model('Post', postSchema);
const Comment = mongoose.model('Comment', commentSchema);

module.exports = { Post, Comment };
