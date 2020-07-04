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
    public class OrganisationPostsUI : IOrganisationPostsUI
    {
        private readonly IOrganisationPostsBL _IOrganisationPostsBL;

        public OrganisationPostsUI(IOrganisationPostsBL IOrganisationPostsBL)
        {
            _IOrganisationPostsBL = IOrganisationPostsBL;
        }


        public List<OrganisationPostInfo> GetOrganisationPosts(int userID)
        {
            return _IOrganisationPostsBL.GetOrganisationPosts(userID);
        }
        public Task<ActionResult<string>> DeleteOrganisationPost(int id)
        {
            return _IOrganisationPostsBL.DeleteOrganisationPost(id);
        }
        public Task<ActionResult<bool>> EditOrganisationPost(OrganisationPost OrgPost)
        {
            return _IOrganisationPostsBL.EditOrganisationPost(OrgPost);
        }

        public Task<ActionResult<bool>> SaveOrganisationPost(OrganisationPost OrgPost)
        {
            return _IOrganisationPostsBL.SaveOrganisationPost(OrgPost);
        }

        public ActionResult<string> OrganisationPostLike(OrganisationPostLike organisationPostLike)
        {
            return _IOrganisationPostsBL.OrganisationPostLike(organisationPostLike);
        }
    }
}
