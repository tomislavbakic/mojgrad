using Backend.BL.Interfaces;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class CommentsUI : ICommentsUI
    {
        private readonly ICommentsBL _ICommentsBL;

        public CommentsUI(ICommentsBL ICommentsBL)
        {
            _ICommentsBL = ICommentsBL;
        }
        public ActionResult<string> CommentLike(CommentLike commentLike)
        {
            return _ICommentsBL.CommentLike(commentLike);
        }

        public Task<ActionResult<string>> DeleteComment(int id)
        {
            return _ICommentsBL.DeleteComment(id);
        }

        public Task<ActionResult<Comment>> PostComment(Comment comment)
        {
            return _ICommentsBL.PostComment(comment);
        }
    }
}
