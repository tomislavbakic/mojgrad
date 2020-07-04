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
    public class OrganisationsUI : IOrganisationsUI
    {
        private readonly IOrganisationsBL _IOrganisationsBL;

        public OrganisationsUI(IOrganisationsBL IOrganisationsBL)
        {
            _IOrganisationsBL = IOrganisationsBL;
        }
        public Organisation AuthenticateOrganisation(Login login)
        {
            return _IOrganisationsBL.AuthenticateOrganisation(login);
        }

        public string GenerateJSONWebToken(Organisation org)
        {
            return _IOrganisationsBL.GenerateJSONWebToken(org);
        }

        public List<OrganisationInfo> GetVerifiedOrganisations()
        {
            return _IOrganisationsBL.GetVerifiedOrganisations();
        }
        public List<OrganisationInfo> GetUnverifiedOrganisations()
        {
            return _IOrganisationsBL.GetUnverifiedOrganisations();
        }

        public Organisation VerifyOrganisations(int id)
        {
            return _IOrganisationsBL.VerifyOrganisations(id);
        }

        public List<OrganisationInfo> GetAllOrganisations()
        {
            return _IOrganisationsBL.GetAllOrganisations();
        }

        public ActionResult<OrganisationInfo> GetOrganisation(int id)
        {
            return _IOrganisationsBL.GetOrganisation(id);
        }

        public Task<ActionResult<bool>> DeleteOrganisation(OrganisationDelete organisationDelete)
        {
            return _IOrganisationsBL.DeleteOrganisation(organisationDelete);
        }

        public Task<bool> ChangeOrgData(Organisation org)
        {
            return _IOrganisationsBL.ChangeOrgData(org);
        }

        public Task<bool> TryToChangePassword(ChangePassword changePassword)
        {
            return _IOrganisationsBL.TryToChangePassword(changePassword);
        }
    }
}
