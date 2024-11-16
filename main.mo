// Import Debug for logging during development
import Debug;

actor SocialMediaPlatform {
    // Type aliases for readability
    type PostId = Nat;
    type CommentId = Nat;

    // Define the Post type
    public type Post = {
        id: PostId;            // Unique identifier for the post
        content: Text;         // Post content
        fileUrl: Text;         // File URL attached to the post
        likes: Nat;            // Number of likes
        comments: [Comment];   // List of comments on the post
    };

    // Define the Comment type
    public type Comment = {
        id: CommentId;         // Unique identifier for the comment
        text: Text;            // Text content of the comment
    };

    // State variables
    private var posts: [Post] = [];           // List of all posts
    private var postCounter: PostId = 0;      // Counter to assign unique Post IDs
    private var commentCounter: CommentId = 0; // Counter to assign unique Comment IDs

    // Create a new post
    public shared({caller}) func createPost(content: Text, fileUrl: Text) : async PostId {
        // Input validation
        if (content.size() == 0 or fileUrl.size() == 0) {
            Debug.print("Invalid post data: content or fileUrl is empty.");
            throw Error.reject("Content and file URL cannot be empty.");
        };

        // Increment the post counter and create a new post
        postCounter += 1;
        let newPost = {
            id = postCounter;
            content = content;
            fileUrl = fileUrl;
            likes = 0;
            comments = [];
        };

        // Append the new post to the list of posts
        posts := Array.append(posts, [newPost]);
        Debug.print("Post created successfully with ID: " # Nat.toText(postCounter));
        return postCounter;
    };

    // Like a post by its ID
    public shared({caller}) func likePost(postId: PostId) : async Bool {
        let postIndex = posts.findIndex(post -> post.id == postId);
        switch (postIndex) {
            case (?index) {
                posts[index].likes += 1;
                Debug.print("Post ID " # Nat.toText(postId) # " liked.");
                return true;
            };
            case null {
                Debug.print("Post ID " # Nat.toText(postId) # " not found.");
                return false;
            };
        }
    };

    // Add a comment to a post by its ID
    public shared({caller}) func addComment(postId: PostId, text: Text) : async Bool {
        // Input validation
        if (text.size() == 0) {
            Debug.print("Comment text cannot be empty.");
            throw Error.reject("Comment text cannot be empty.");
        };

        let postIndex = posts.findIndex(post -> post.id == postId);
        switch (postIndex) {
            case (?index) {
                // Increment the comment counter and add a new comment
                commentCounter += 1;
                let newComment = {
                    id = commentCounter;
                    text = text;
                };
                posts[index].comments := Array.append(posts[index].comments, [newComment]);
                Debug.print("Comment added to Post ID " # Nat.toText(postId));
                return true;
            };
            case null {
                Debug.print("Post ID " # Nat.toText(postId) # " not found.");
                return false;
            };
        }
    };

    // Get all posts
    public query func getPosts() : async [Post] {
        Debug.print("Fetching all posts. Total: " # Nat.toText(posts.size()));
        return posts;
    };
};
