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
    private var nextPostId: PostId = 1;
    private var nextCommentId: CommentId = 1;

    public func createPost(content: Text, fileUrl: Text): async Bool {
        let newPost = {
            id = nextPostId;
            content = content;
            fileUrl = fileUrl;
            likes = 0;
            comments = [];
        };
        posts := Array.append(posts, [newPost]);
        nextPostId += 1;
        return true;
    };

    public func likePost(postId: PostId): async Bool {
        for (index in 0 : Array.size(posts)) {
            if (posts[index].id == postId) {
                posts[index].likes += 1;
                return true;
            };
        };
        return false;
    };

    public func addComment(postId: PostId, text: Text): async Bool {
        let comment = { id = nextCommentId; text = text };
        for (index in 0 : Array.size(posts)) {
            if (posts[index].id == postId) {
                posts[index].comments := Array.append(posts[index].comments, [comment]);
                nextCommentId += 1;
                return true;
            };
        };
        return false;
    };

    public query func getPosts(): async [Post] {
        return posts;
    };
};
