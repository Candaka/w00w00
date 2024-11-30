import Debug "mo:base/Debug";
import JSON "mo:json";

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

    // Fungsi untuk memuat JSON
    public func loadPostsFromJSON(jsonString: Text): async Bool {
        // Parse JSON string
        let parsed = JSON.parse(jsonString);
        switch (parsed) {
            case (?jsonObj) {
                // Parsing array "posts"
                let jsonPosts = JSON.toVariant(jsonObj)["posts"];
                switch (jsonPosts) {
                    case (?jsonPostArray) {
                        let postArray = JSON.toArray(jsonPostArray);
                        for (jsonPost in postArray) {
                            // Parsing setiap post
                            let parsedPost = parsePost(jsonPost);
                            switch (parsedPost) {
                                case (?post) {
                                    posts := Array.append(posts, [post]);
                                };
                                case null {
                                    Debug.print("Failed to parse post.");
                                };
                            };
                        };
                        return true;
                    };
                    case null {
                        Debug.print("Posts array not found.");
                        return false;
                    };
                };
            };
            case null {
                Debug.print("Invalid JSON format.");
                return false;
            };
        };
    };

    // Fungsi untuk memparsing post dari JSON
    private func parsePost(jsonPost: JSON.JSON): ?Post {
        let id = JSON.toNat(JSON.toVariant(jsonPost)["id"]);
        let content = JSON.toText(JSON.toVariant(jsonPost)["content"]);
        let fileUrl = JSON.toText(JSON.toVariant(jsonPost)["fileUrl"]);
        let likes = JSON.toNat(JSON.toVariant(jsonPost)["likes"]);
        let jsonComments = JSON.toVariant(jsonPost)["comments"];

        if (id != null and content != null and fileUrl != null and likes != null) {
            let comments: [Comment] = [];
            switch (jsonComments) {
                case (?commentArray) {
                    let parsedComments = JSON.toArray(commentArray);
                    for (jsonComment in parsedComments) {
                        let parsedComment = parseComment(jsonComment);
                        if (parsedComment != null) {
                            comments := Array.append(comments, [parsedComment]);
                        };
                    };
                };
                case null {};
            };
            return ?{
                id = id;
                content = content;
                fileUrl = fileUrl;
                likes = likes;
                comments = comments;
            };
        };
        return null;
    };

    // Fungsi untuk memparsing komentar dari JSON
    private func parseComment(jsonComment: JSON.JSON): ?Comment {
        let id = JSON.toNat(JSON.toVariant(jsonComment)["id"]);
        let text = JSON.toText(JSON.toVariant(jsonComment)["text"]);

        if (id != null and text != null) {
            return ?{ id = id; text = text };
        };
        return null;
    };

    // Query semua post
    public query func getPosts(): async [Post] {
        return posts;
    };
};
