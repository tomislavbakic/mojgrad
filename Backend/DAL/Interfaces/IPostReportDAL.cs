﻿using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IPostReportDAL
    {
        IEnumerable<PostReport> GetAllPostsReports();
        IEnumerable<PostReport> GetAllPostsReportsByPostID(int postID);
        Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostReportsInfo();
        Task AddPostReport(PostReport postReport);
        Task<ActionResult<bool>> DeletePostReport(int id);
    }
}
