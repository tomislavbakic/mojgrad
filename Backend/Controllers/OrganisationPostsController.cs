using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using Backend.Models.ViewModels;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrganisationPostsController : ControllerBase
    {
        private readonly DataContext _context;
        private readonly IOrganisationPostsUI _IOrganisationPostsUI;

        public OrganisationPostsController(DataContext context, IOrganisationPostsUI IOrganisationPostsUI)
        {
            _context = context;
            _IOrganisationPostsUI = IOrganisationPostsUI;
        }

        [Authorize]
        [Route("userid={userID}")]
        [HttpGet]
        public List<OrganisationPostInfo> GetOrganisationPosts(int userID)
        {
            return _IOrganisationPostsUI.GetOrganisationPosts(userID);
        }

        [Authorize]
        [HttpPut]
        public async Task<ActionResult<bool>> EditOrganisationPost(OrganisationPost orgPost)
        {
            return await _IOrganisationPostsUI.EditOrganisationPost(orgPost);
        }

        [Authorize]
        [HttpPost]
        public async Task<ActionResult<bool>> AddOrganisationPost(OrganisationPost OrgPost)
        {
            return await _IOrganisationPostsUI.SaveOrganisationPost(OrgPost);
        }

        // DELETE: api/Ranks/5
        [Authorize]
        [HttpDelete("{id}")]
        public async Task<ActionResult<string>> DeleteOrganisationPost(int id)
        {
            return await _IOrganisationPostsUI.DeleteOrganisationPost(id);
        }

        [Authorize]
        [Route("Likes")]
        [HttpPost]
        public ActionResult<string> OrganisationPostLike(OrganisationPostLike organisationPostLike)
        {
            return _IOrganisationPostsUI.OrganisationPostLike(organisationPostLike);
        }

    }
}
