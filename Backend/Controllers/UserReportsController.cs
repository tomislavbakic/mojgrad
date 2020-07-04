using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using Backend.UI.Interfaces;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Authorization;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserReportsController : ControllerBase
    {
        private readonly IUserReportsUI _IUserReportsUI;

        public UserReportsController(IUserReportsUI IUserReportsUI)
        {
            _IUserReportsUI = IUserReportsUI;
        }

        [Authorize]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReports()
        {
            return await _IUserReportsUI.GetUserReports();
            //_context.UserReports.ToListAsync()
        }

        [Authorize]
        [HttpGet("{id}")]
        public async Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReport(int id)
        {
            return await _IUserReportsUI.GetUserReportByID(id);
        }

        [Authorize]
        [HttpPost]
        public async Task<ActionResult<UserReport>> PostUserReport(UserReport userReport)
        {
            await _IUserReportsUI.PostUserReport(userReport);
            

            return Ok();
        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<ActionResult<bool>> DeleteUserReport(int id)
        {
            return await _IUserReportsUI.DeleteUserReport(id);
        }

        
    }
}
