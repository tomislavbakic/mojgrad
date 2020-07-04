using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IOrganisationPostsBL
    {
        List<OrganisationPostInfo> GetOrganisationPosts(int userID);
        public Task<ActionResult<string>> DeleteOrganisationPost(int id);
        public Task<ActionResult<bool>> EditOrganisationPost(OrganisationPost OrgPost);
        public Task<ActionResult<bool>> SaveOrganisationPost(OrganisationPost OrgPost);
        ActionResult<string> OrganisationPostLike(OrganisationPostLike organisationPostLike);
    }
}
