using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class AdminsBL : IAdminsBL
    {
        private readonly IAdminsDAL _IAdminsDAL;
        private IConfiguration _config;
        public AdminsBL(IAdminsDAL IAdminsDAL, IConfiguration config)
        {
            _IAdminsDAL = IAdminsDAL;
            _config = config;
        }

        public bool AddNewAdmin(Admin admin)
        {
            return _IAdminsDAL.AddNewAdmin(admin);
        }

        public Admin AuthenticateUser(Admin admin)
        {
            return _IAdminsDAL.AuthenticateUser(admin);
        }

        public Task<ActionResult<bool>> DeleteOrganisation(int id)
        {
            return _IAdminsDAL.DeleteOrganisation(id);
        }

        public Task<ActionResult<bool>> DeleteUser(int id)
        {
            return _IAdminsDAL.DeleteUser(id);
        }

        public string GenerateJSONWebToken(Admin admin)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, "admin"),
                new Claim(JwtRegisteredClaimNames.NameId, admin.ID.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti,Guid.NewGuid().ToString()),
                new Claim("Head", admin.Head.ToString())

            };

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Issuer"],
                claims,
                expires: DateTime.Now.AddMinutes(1440),
                signingCredentials: credentials);

            var encodeToken = new JwtSecurityTokenHandler().WriteToken(token);
            return encodeToken;
        }

        public List<AdminInfo> GetAdminNames()
        {
            return _IAdminsDAL.GetAdminNames();
        }

        public StatisticsInfo GetStatistics()
        {
            return _IAdminsDAL.GetStatistics();
        }

        public GenderInfo GenderStats()
        {
            return _IAdminsDAL.GenderStats();
        }

        public bool DeleteAdmin(string name)
        {
            return _IAdminsDAL.DeleteAdmin(name);
        }
    }
}
