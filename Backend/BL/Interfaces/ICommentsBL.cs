using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface ICommentsBL
    {
        ActionResult<string> CommentLike(CommentLike commentLike);
        Task<ActionResult<Comment>> PostComment(Comment comment);
        Task<ActionResult<string>> DeleteComment(int id);
    }
}
