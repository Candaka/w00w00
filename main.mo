import Debug;
actor SocialMediaPlatform {
    type PostId = Nat;
    type CommentId = Nat;

    public type Post = {
        id: PostId;
        content: Text;
        fileUrl: Text; 
        likes: Nat;
        comments: [Comment];
    };

    public type Comment = {
        id: CommentId;
        text: Text;
    };

    private var posts: [Post] = [];
    private var postCounter: PostId = 0;
    private var commentCounter: CommentId = 0;

    public shared({caller}) func createPost(content: Text, fileUrl: Text) : async PostId {
        postCounter += 1;
        let newPost = {
            id = postCounter;
            content = content;
            fileUrl = fileUrl;
            likes = 0;
            comments = [];
        };
        posts := Array.append(posts, [newPost]);
        return postCounter;
    };

    public shared({caller}) func likePost(postId: PostId) : async Bool {
        for (index in Iter.range(0, posts.size() - 1)) {
            if (posts[index].id == postId) {
                posts[index].likes += 1;
                return true;
            };
        };
        return false;
    };

    public shared({caller}) func addComment(postId: PostId, text: Text) : async Bool {
        for (index in Iter.range(0, posts.size() - 1)) {
            if (posts[index].id == postId) {
                commentCounter += 1;
                let newComment = {
                    id = commentCounter;
                    text = text;
                };
                posts[index].comments := Array.append(posts[index].comments, [newComment]);
                return true;
            };
        };
        return false;
    };

    public query func getPosts() : async [Post] {
        return posts;
    };
};
