using Backend.BL.Interfaces;
using Backend.Models;
using Backend.Models.ViewModels;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class CommentReportsUI : ICommentReportsUI
    {
        private readonly ICommentReportsBL _ICommentReportsBL;

        public CommentReportsUI(ICommentReportsBL ICommentReportsBL)
        {
            _ICommentReportsBL = ICommentReportsBL;
        }

        public Task AddCommentReport(CommentReport commentReport)
        {
            return _ICommentReportsBL.AddCommentReport(commentReport);
        }

        public Task<ActionResult<bool>> DeleteCommentReport(int id)
        {
            return _ICommentReportsBL.DeleteCommentReport(id);
        }

        public Task<ActionResult<IEnumerable<CommentReportInfo>>> GetCommentReportsInfo()
        {
            return _ICommentReportsBL.GetCommentReportsInfo();
        }
    }
}
