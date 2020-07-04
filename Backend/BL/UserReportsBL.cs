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
    public class UserReportsBL : IUserReportsBL
    {
        private readonly IUserReportsDAL _IUserReportsDAL;

        public UserReportsBL(IUserReportsDAL IUserReportsDAL)
        {
            _IUserReportsDAL = IUserReportsDAL;
        }
        public Task<ActionResult<bool>> DeleteUserReport(int id)
        {
            return _IUserReportsDAL.DeleteUserReport(id);
        }

        public Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReportByID(int id)
        {
            return _IUserReportsDAL.GetUserReportByID(id);
        }

        public Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReports()
        {
            return _IUserReportsDAL.GetUserReports();
        }

        public Task PostUserReport(UserReport userReport)
        {
            return _IUserReportsDAL.PostUserReport(userReport);
        }
    }
}
