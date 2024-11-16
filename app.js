import React, { useState, useEffect } from "react";
import { Actor, HttpAgent } from "@dfinity/agent";
import { idlFactory, canisterId } from "./declarations/backend";

const App = () => {
  // State variables to manage posts, input content, and file URL
  const [posts, setPosts] = useState([]);
  const [content, setContent] = useState("");
  const [fileUrl, setFileUrl] = useState("");

  // Initialize the HttpAgent and backend actor for interacting with the canister
  const agent = new HttpAgent();
  const backend = Actor.createActor(idlFactory, { agent, canisterId });

  // Fetch posts when the component is mounted
  useEffect(() => {
    const fetchPosts = async () => {
      try {
        const data = await backend.getPosts();
        setPosts(data);
      } catch (error) {
        console.error("Error fetching posts:", error);
        alert("Failed to fetch posts. Please try again.");
      }
    };
    fetchPosts();
  }, [backend]);

  // Function to create a new post
  const createPost = async () => {
    if (!content || !fileUrl) {
      alert("Content and file URL are required!");
      return;
    }

    try {
      await backend.createPost(content, fileUrl);
      setContent("");
      setFileUrl("");
      alert("Post created successfully!");
      refreshPosts(); // Refresh posts after creating a new one
    } catch (error) {
      console.error("Error creating post:", error);
      alert("Failed to create post. Please try again.");
    }
  };

  // Function to like a post
  const likePost = async (id) => {
    try {
      await backend.likePost(id);
      alert("Post liked!");
      refreshPosts(); // Refresh posts after liking one
    } catch (error) {
      console.error("Error liking post:", error);
      alert("Failed to like post. Please try again.");
    }
  };

  // Function to add a comment to a post
  const addComment = async (id, comment) => {
    if (!comment) {
      alert("Comment cannot be empty!");
      return;
    }

    try {
      await backend.addComment(id, comment);
      alert("Comment added!");
      refreshPosts(); // Refresh posts after adding a comment
    } catch (error) {
      console.error("Error adding comment:", error);
      alert("Failed to add comment. Please try again.");
    }
  };

  // Helper function to refresh posts
  const refreshPosts = async () => {
    try {
      const data = await backend.getPosts();
      setPosts(data);
    } catch (error) {
      console.error("Error refreshing posts:", error);
    }
  };

  return (
    <div>
      <h1>Decentralized Social Media</h1>

      {/* Section for creating a new post */}
      <div>
        <h2>Create Post</h2>
        <input
          type="text"
          placeholder="Content"
          value={content}
          onChange={(e) => setContent(e.target.value)}
        />
        <input
          type="text"
          placeholder="File URL"
          value={fileUrl}
          onChange={(e) => setFileUrl(e.target.value)}
        />
        <button onClick={createPost}>Post</button>
      </div>

      {/* Section for displaying posts */}
      <div>
        <h2>Posts</h2>
        {posts.length > 0 ? (
          posts.map((post) => (
            <div key={post.id} style={{ border: "1px solid #ccc", margin: "10px", padding: "10px" }}>
              <h3>{post.content}</h3>
              {post.fileUrl && (
                <img
                  src={post.fileUrl}
                  alt="Post attachment"
                  style={{ maxWidth: "200px", marginBottom: "10px" }}
                />
              )}
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
          ))
        ) : (
          <p>No posts available. Be the first to create one!</p>
        )}
      </div>
    </div>
  );
};

export default App;
