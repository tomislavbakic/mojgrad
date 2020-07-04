using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class CommentReportsBL : ICommentReportsBL
    {
        private readonly ICommentReportsDAL _ICommentReportsDAL;
        
        public CommentReportsBL(ICommentReportsDAL ICommentReportsDAL)
        {
            _ICommentReportsDAL = ICommentReportsDAL;
        }

        public Task AddCommentReport(CommentReport commentReport)
        {
            return _ICommentReportsDAL.AddCommentReport(commentReport);
        }

        public Task<ActionResult<bool>> DeleteCommentReport(int id)
        {
            return _ICommentReportsDAL.DeleteCommentReport(id);
        }

        public Task<ActionResult<IEnumerable<CommentReportInfo>>> GetCommentReportsInfo()
        {
            return _ICommentReportsDAL.GetCommentReportsInfo();
        }
    }
}
