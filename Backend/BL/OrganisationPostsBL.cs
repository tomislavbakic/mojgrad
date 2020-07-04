using Backend.BL.Interfaces;
using Backend.DAL;
using Backend.DAL.Interfaces;
using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class OrganisationPostsBL : IOrganisationPostsBL
    {
        private readonly IOrganisationPostsDAL _IOrganisationPostsDAL;

        public OrganisationPostsBL(IOrganisationPostsDAL IOrganisationPostsDAL)
        {
            _IOrganisationPostsDAL = IOrganisationPostsDAL;
        }
        public List<OrganisationPostInfo> GetOrganisationPosts(int userID)
        {
            return _IOrganisationPostsDAL.GetOrganisationPosts(userID);
        }

        public Task<ActionResult<string>> DeleteOrganisationPost(int id)
        {
            return _IOrganisationPostsDAL.DeleteOrganisationPost(id);
        }
        public Task<ActionResult<bool>> EditOrganisationPost(OrganisationPost OrgPost)
        {
            return _IOrganisationPostsDAL.EditOrganisationPost(OrgPost);
        }

        public Task<ActionResult<bool>> SaveOrganisationPost(OrganisationPost OrgPost)
        {
            return _IOrganisationPostsDAL.SaveOrganisationPost(OrgPost);
        }

        public ActionResult<string> OrganisationPostLike(OrganisationPostLike organisationPostLike)
        {
            return _IOrganisationPostsDAL.OrganisationPostLike(organisationPostLike);
        }
    }
}
