using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class CommentsBL : ICommentsBL
    {
        private readonly ICommentsDAL _ICommentsDAL;

        public CommentsBL(ICommentsDAL ICommentsDAL)
        {
            _ICommentsDAL = ICommentsDAL;
        }
        public ActionResult<string> CommentLike(CommentLike commentLike)
        {
            return _ICommentsDAL.CommentLike(commentLike);
        }

        public Task<ActionResult<string>> DeleteComment(int id)
        {
            return _ICommentsDAL.DeleteComment(id);
        }

        public Task<ActionResult<Comment>> PostComment(Comment comment)
        {
            return _ICommentsDAL.PostComment(comment);
        }
    }
}
