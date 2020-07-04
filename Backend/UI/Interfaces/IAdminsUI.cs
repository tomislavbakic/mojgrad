using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface IAdminsUI
    {
        Admin AuthenticateUser(Admin admin);
        string GenerateJSONWebToken(Admin admin);
        Task<ActionResult<bool>> DeleteUser(int id);
        bool AddNewAdmin(Admin admin);
        Task<ActionResult<bool>> DeleteOrganisation(int id);
        List<AdminInfo> GetAdminNames();
        StatisticsInfo GetStatistics();
        public GenderInfo GenderStats();
        public bool DeleteAdmin(string name);
    }
}
