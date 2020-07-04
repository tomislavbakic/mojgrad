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
    public class UserReportsUI : IUserReportsUI
    {
        private readonly IUserReportsBL _IUserReportsBL;

        public UserReportsUI(IUserReportsBL IUserReportsBL)
        {
            _IUserReportsBL = IUserReportsBL;
        }
        public Task<ActionResult<bool>> DeleteUserReport(int id)
        {
            return _IUserReportsBL.DeleteUserReport(id);
        }

        public Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReportByID(int id)
        {
            return _IUserReportsBL.GetUserReportByID(id);
        }

        public Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReports()
        {
            return _IUserReportsBL.GetUserReports();
        }

        public Task PostUserReport(UserReport userReport)
        {
            return _IUserReportsBL.PostUserReport(userReport);
        }
    }
}
