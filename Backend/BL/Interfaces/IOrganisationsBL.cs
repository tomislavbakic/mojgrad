﻿using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IOrganisationsBL
    {
        Organisation AuthenticateOrganisation(Login login);
        string GenerateJSONWebToken(Organisation org);
        public List<OrganisationInfo> GetVerifiedOrganisations();
        public List<OrganisationInfo> GetUnverifiedOrganisations();
        public Organisation VerifyOrganisations(int id);
        public List<OrganisationInfo> GetAllOrganisations();
        ActionResult<OrganisationInfo> GetOrganisation(int id);
        Task<ActionResult<bool>> DeleteOrganisation(OrganisationDelete organisationDelete);
        Task<bool> ChangeOrgData(Organisation org);
        Task<bool> TryToChangePassword(ChangePassword changePassword);
    }
}
