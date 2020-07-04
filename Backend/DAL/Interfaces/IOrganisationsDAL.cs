using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IOrganisationsDAL
    {
        Organisation AuthenticateOrganisation(Login login);
        public List<OrganisationInfo> GetVerifiedOrganisations(int ver);
        public Organisation VerifyOrganisations(int id);
        public List<OrganisationInfo> GetAllOrganisations();
        ActionResult<OrganisationInfo> GetOrganisationAsync(int id);
        Task<ActionResult<bool>> DeleteOrganisation(OrganisationDelete organisationDelete);
        Task<bool> ChangeOrgData(Organisation org);
        Task<bool> TryToChangePassword(ChangePassword changePassword);
    }
}
