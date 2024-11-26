import Debug {
    actor SocialMediaPlatform { //Ganti pake nama media sosial kita
        type PostId = Nat;
        type CommentID = Nat;

        public type Comment {
            id: CommentID;
            content: Text;
            fileUrl: Text;
            likes: Nat;
            comments: [Comment];

        };

        public type Comment = {
            id: CommentID;
            text: Text;
        };

        private var posts: [Post] = [];
        private var postCounter: PostId = 0;
        private var commentCounter: CommentID = 0;

        public shared({caller}) func createPost(content: Text, fileUrl: Text) : async PostId {
            postCounter += 1;
            let newPost = {
                id = postCounter;
                content = content;
                fileUrl = fileUrl;
                likes = 0;
                comments = [];
            };
            posts := posts # [newPost];
            return postCounter;
        };

        public shared({caller}) func likePost(PostId: PostId) : async Bool {
            let index = posts.indexes().findOpt(func(i) { posts[i].id == PostId });
            switch (index) {
                case (?idx) {
                    posts[idx].likes += 1;
                    return true;
                };
                case (_) return false;
            };
        };

        public shared({caller}) func addComment(postId: PostId, text: Text) : async Bool {
            let index = posts.indexes().findOpt(func(i) { posts[i].id == postId});
            switch (index) {
                case (?idx) {
                    commentCounter += 1;
                    let newComment = { id = commentCounter; text = text };
                    posts[idx].comments := posts[idx].comments # [newComment];
                    return true;
                };
                case (_) return false;
            };
        };

        public query func getPosts() : async [Post] {
            return posts;
        };
    };

};