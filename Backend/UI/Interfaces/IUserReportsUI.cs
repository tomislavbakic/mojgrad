using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface IUserReportsUI
    {

        Task<ActionResult<bool>> DeleteUserReport(int id);
        Task PostUserReport(UserReport userReport);
        Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReportByID(int id);
        Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReports();
    }
}
