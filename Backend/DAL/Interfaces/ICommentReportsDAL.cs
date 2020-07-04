using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface ICommentReportsDAL
    {
        Task<ActionResult<IEnumerable<CommentReportInfo>>> GetCommentReportsInfo();
        Task AddCommentReport(CommentReport commentReport);
        Task<ActionResult<bool>> DeleteCommentReport(int id);
    }
}
