import React, { useState, useEffect } from "react";
import { Actor, HttpAgent } from "@dfinity/agent";
import { idlFactory, canisterId } from "./declarations/backend";

const App = () => {
  const [posts, setPosts] = useState([]);
  const [content, setContent] = useState("");
  const [fileUrl, setFileUrl] = useState("");

  const agent = new HttpAgent();
  const backend = Actor.createActor(idlFactory, { agent, canisterId });

  useEffect(() => {
    const fetchPosts = async () => {
      const data = await backend.getPosts();
      setPosts(data);
    };
    fetchPosts();
  }, []);

  const createPost = async () => {
    if (content && fileUrl) {
      await backend.createPost(content, fileUrl);
      setContent("");
      setFileUrl("");
      alert("Post created successfully!");
    } else {
      alert("Content and file URL are required!");
    }
  };

  const likePost = async (id) => {
    await backend.likePost(id);
    alert("Post liked!");
  };

  const addComment = async (id, comment) => {
    await backend.addComment(id, comment);
    alert("Comment added!");
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
          type="text"
          placeholder="File URL"
          value={fileUrl}
          onChange={(e) => setFileUrl(e.target.value)}
        />
        <button onClick={createPost}>Post</button>
      </div>

      <div>
        <h2>Posts</h2>
        {posts.map((post) => (
          <div key={post.id}>
            <h3>{post.content}</h3>
            <img src={post.fileUrl} alt="Post attachment" style={{ maxWidth: "200px" }} />
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
