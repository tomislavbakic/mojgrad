using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IUserReportsBL
    {
        Task<ActionResult<bool>> DeleteUserReport(int id);
        Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReportByID(int id);
        Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReports();
        Task PostUserReport(UserReport userReport);
    }
}
