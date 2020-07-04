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
    public class OrganisationsBL : IOrganisationsBL
    {
        private readonly IOrganisationsDAL _IOrganisationsDAL;
        private IConfiguration _config;

        public OrganisationsBL(IOrganisationsDAL IOrganisationsDAL, IConfiguration config)
        {
            _IOrganisationsDAL = IOrganisationsDAL;
            _config = config;
        }
        public Organisation AuthenticateOrganisation(Login login)
        {
            return _IOrganisationsDAL.AuthenticateOrganisation(login);
        }

        public string GenerateJSONWebToken(Organisation org)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, "org"),
                new Claim(JwtRegisteredClaimNames.NameId, org.ID.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti,Guid.NewGuid().ToString())
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

        public List<OrganisationInfo> GetVerifiedOrganisations()
        {
            return _IOrganisationsDAL.GetVerifiedOrganisations(1);
        }

        public List<OrganisationInfo> GetUnverifiedOrganisations()
        {
            return _IOrganisationsDAL.GetVerifiedOrganisations(0);
        }
        public Organisation VerifyOrganisations(int id)
        {
            return _IOrganisationsDAL.VerifyOrganisations(id);
        }

        public List<OrganisationInfo> GetAllOrganisations()
        {
            return _IOrganisationsDAL.GetAllOrganisations();
        }

        public ActionResult<OrganisationInfo> GetOrganisation(int id)
        {
            return _IOrganisationsDAL.GetOrganisationAsync(id);
        }

        public Task<ActionResult<bool>> DeleteOrganisation(OrganisationDelete organisationDelete)
        {
            return _IOrganisationsDAL.DeleteOrganisation(organisationDelete);
        }

        public Task<bool> ChangeOrgData(Organisation org)
        {
            return _IOrganisationsDAL.ChangeOrgData(org);
        }

        public Task<bool> TryToChangePassword(ChangePassword changePassword)
        {
            return _IOrganisationsDAL.TryToChangePassword(changePassword);
        }
    }
}
