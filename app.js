import React, { useState, useEffect } from "react";
import { Actor, HttpAgent } from "@dfinity/agent";
import { idlFactory, canisterId } from "./declarations/backend";

const App = () => {
  const [posts, setPosts] = useState([]);
  const [content, setContent] = useState("");
  const [file, setFile] = useState(null);

  const agent = new HttpAgent();
  const backend = Actor.createActor(idlFactory, { agent, canisterId });

  useEffect(() => {
    const fetchPosts = async () => {
      try {
        const data = await backend.getPosts();
        setPosts(data);
      } catch (error) {
        console.error("Error fetching posts:", error);
        alert("Failed to load posts. Please try again.");
      }
    };
    fetchPosts();
  }, []);

  const uploadFileToIPFS = async (file) => {
    try {
      const formData = new FormData();
      formData.append("file", file);

      const response = await fetch("https://ipfs.infura.io:5001/api/v0/add", {
        method: "POST",
        body: formData,
      });
      const data = await response.json();
      return `https://ipfs.infura.io/ipfs/${data.Hash}`;
    } catch (error) {
      console.error("Error uploading file:", error);
      alert("File upload failed. Please try again.");
      return null;
    }
  };

  const createPost = async () => {
    if (content && file) {
      const fileUrl = await uploadFileToIPFS(file);
      if (!fileUrl) return;

      try {
        await backend.createPost(content, fileUrl);
        setContent("");
        setFile(null);
        alert("Post created successfully!");
        window.location.reload(); // Refresh posts
      } catch (error) {
        console.error("Error creating post:", error);
        alert("Failed to create post. Please try again.");
      }
    } else {
      alert("Content and file are required!");
    }
  };

  const likePost = async (id) => {
    try {
      await backend.likePost(id);
      setPosts((prevPosts) =>
        prevPosts.map((post) =>
          post.id === id ? { ...post, likes: post.likes + 1 } : post
        )
      );
    } catch (error) {
      console.error("Error liking post:", error);
      alert("Failed to like the post. Please try again.");
    }
  };

  const addComment = async (id, comment) => {
    if (!comment) return;
    try {
      await backend.addComment(id, comment);
      alert("Comment added!");
      window.location.reload();
    } catch (error) {
      console.error("Error adding comment:", error);
      alert("Failed to add comment. Please try again.");
    }
  };

  return (
    <div>
      <h1>Decentralized Social Media</h1>
      <div>
        <h2>Create Post</h2>
        <input
          type="text"
          placeholder="Content"
          value={content}
          onChange={(e) => setContent(e.target.value)}
        />
        <input
          type="file"
          onChange={(e) => setFile(e.target.files[0])}
          accept="image/*"
        />
        <button onClick={createPost}>Post</button>
      </div>

      <div>
        <h2>Posts</h2>
        {posts.map((post) => (
          <div key={post.id}>
            <h3>{post.content}</h3>
            <img
              src={post.fileUrl}
              alt="Post"
              style={{ maxWidth: "200px" }}
            />
            <p>Likes: {post.likes}</p>
            <button onClick={() => likePost(post.id)}>Like</button>
            <button
              onClick={() => {
                const comment = prompt("Enter your comment:");
                if (comment) addComment(post.id, comment);
              }}
            >
              Comment
            </button>
            <div>
              <h4>Comments:</h4>
              <ul>
                {post.comments.map((comment) => (
                  <li key={comment.id}>{comment.text}</li>
                ))}
              </ul>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default App;
