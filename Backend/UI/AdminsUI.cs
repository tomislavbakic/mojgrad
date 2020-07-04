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
    public class AdminsUI : IAdminsUI
    {
        private readonly IAdminsBL _IAdminsBL;

        public AdminsUI(IAdminsBL IAdminsBL)
        {
            _IAdminsBL = IAdminsBL;
        }

        public bool AddNewAdmin(Admin admin)
        {
            return _IAdminsBL.AddNewAdmin(admin);
        }

        public Admin AuthenticateUser(Admin admin)
        {
            return _IAdminsBL.AuthenticateUser(admin);
        }

        public Task<ActionResult<bool>> DeleteOrganisation(int id)
        {
            return _IAdminsBL.DeleteOrganisation(id);
        }

        public Task<ActionResult<bool>> DeleteUser(int id)
        {
            return _IAdminsBL.DeleteUser(id);
        }

        public string GenerateJSONWebToken(Admin admin)
        {
            return _IAdminsBL.GenerateJSONWebToken(admin);
        }

        public List<AdminInfo> GetAdminNames()
        {
            return _IAdminsBL.GetAdminNames();
        }

        public StatisticsInfo GetStatistics()
        {
            return _IAdminsBL.GetStatistics();
        }

        public GenderInfo GenderStats()
        {
            return _IAdminsBL.GenderStats();
        }

        public bool DeleteAdmin(string name)
        {
            return _IAdminsBL.DeleteAdmin(name);
        }
    }
}
