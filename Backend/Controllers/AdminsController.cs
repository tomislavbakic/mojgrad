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
    public class AdminsController : ControllerBase
    {
        private readonly IAdminsUI _IAdminsUI;

        public AdminsController(IAdminsUI IAdminsUI)
        {
            _IAdminsUI = IAdminsUI;
        }

        

        [Route("login")]
        [HttpPost]
        public IActionResult Login(Admin admin)
        {
            IActionResult response = Unauthorized();

            Admin user = _IAdminsUI.AuthenticateUser(admin);


            if (user != null)
            {
                string tokenStr = _IAdminsUI.GenerateJSONWebToken(user);
                response = Ok(new { token = tokenStr });
            }
            return response;
        }

        [Authorize]
        [Route("userdelete/{id}")]
        [HttpDelete]
        public async Task<ActionResult<bool>> DeleteUser(int id)
        {
            return await _IAdminsUI.DeleteUser(id);
        }

        [Authorize]
        [Route("deleteOrganisation/{id}")]
        [HttpDelete]
        public async Task<ActionResult<bool>> DeleteOrganisation(int id)
        {
            return await _IAdminsUI.DeleteOrganisation(id);
        }

        [Authorize]
        [HttpPost]
        public bool AddNewAdmin(Admin admin)
        {
            return _IAdminsUI.AddNewAdmin(admin);
        }

        [Authorize]
        [HttpGet]
        public List<AdminInfo> GetAdminNames()
        {
            return _IAdminsUI.GetAdminNames();
        }

        [Authorize]
        [Route("getStatistics")]
        [HttpGet]
        public StatisticsInfo GetStatistics()
        {
            return _IAdminsUI.GetStatistics();
        }

        [Authorize]
        [Route("genderStats")]
        [HttpGet]
        public GenderInfo GenderStats()
        {
            return _IAdminsUI.GenderStats();
        }

        [Authorize]
        [Route("deleteAdmin/{name}")]
        [HttpDelete]
        public bool DeleteAdmin(string name)
        {
            return  _IAdminsUI.DeleteAdmin(name);
        }




    }
}
