using Backend.DAL.Interfaces;
using Backend.Data;
using Backend.Functions;
using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class OrganisationPostsDAL : IOrganisationPostsDAL
    {
        private readonly DataContext _context;

        public OrganisationPostsDAL(DataContext context)
        {
            _context = context;
        }
        

        
        List<OrganisationPostInfo> IOrganisationPostsDAL.GetOrganisationPosts(int userID)
        {
            var orgPosts = _context.OrganisationPosts.Include(x => x.OrganisationPostLikes).Include(x => x.Organisation).ToList();

            List<OrganisationPostInfo> orgPostList = new List<OrganisationPostInfo>();

            foreach (var item in orgPosts)
            {
                OrganisationPostInfo op = new OrganisationPostInfo();

                op.ID = item.ID;
                op.Text = item.Text;
                op.ImagePath = item.ImagePath;
                op.Time = item.Time;
                op.OrganisationID = item.OrganisationID;
                op.Name = item.Organisation.Name;
                op.PhoneNumber = item.Organisation.PhoneNumber;
                op.Activity = item.Organisation.Activity;
                op.Location = item.Organisation.Location;
                op.OrgImagePath = item.Organisation.ImagePath;
                op.Email = item.Organisation.Email;
                op.LikesNumber = item.OrganisationPostLikes.Count(x => x.OrganisationPostID == item.ID && x.LikeOrDislike == 1);
                op.DislikesNumber = item.OrganisationPostLikes.Count(x => x.OrganisationPostID == item.ID && x.LikeOrDislike == -1);

                var isItLikedOrDisliked = _context.OrganisationPostLikes.FirstOrDefault(x => x.OrganisationPostID == item.ID && x.UserDataID == userID);
                if (isItLikedOrDisliked == null)
                    op.isLikedOrDisliked = 0;
                else
                {
                    op.isLikedOrDisliked = isItLikedOrDisliked.LikeOrDislike;
                }

                orgPostList.Add(op);

            }

            orgPostList.Reverse();

            return orgPostList;
        }

        public async Task<ActionResult<string>> DeleteOrganisationPost(int id)
        {
            try
            {
                var OrganisationPosts = await _context.OrganisationPosts.FindAsync(id);

                if (OrganisationPosts.ImagePath != null)
                {
                    ImageDelete imgDelete = new ImageDelete();
                    imgDelete.ImageDeleteURL(OrganisationPosts.ImagePath);
                }

                

                _context.OrganisationPosts.Remove(OrganisationPosts);
                await _context.SaveChangesAsync();
                return "Rank deleted";
            }
            catch (Exception)
            {
                return "Failed to delete rank with that id";
            }
        }

        public async Task<ActionResult<bool>> EditOrganisationPost(OrganisationPost OrgPost)
        {
            var orgPostsEdit = await _context.OrganisationPosts.FirstOrDefaultAsync(x => x.ID == OrgPost.ID);

            if (orgPostsEdit == null)
            {
                return false;
            }
            else
            {
                try
                {
                    if (orgPostsEdit.ImagePath != null)
                    {
                        ImageDelete imgDelete = new ImageDelete();
                        imgDelete.ImageDeleteURL(orgPostsEdit.ImagePath);
                    }

                    orgPostsEdit.Text = OrgPost.Text;
                    orgPostsEdit.ImagePath = OrgPost.ImagePath;
                    orgPostsEdit.Time = OrgPost.Time;
                    orgPostsEdit.OrganisationID = OrgPost.OrganisationID;


                    _context.OrganisationPosts.Update(orgPostsEdit);

                    _context.SaveChanges();

                    return true;
                }
                catch (Exception)
                {

                    return false;
                }

            }
        }

        public async Task<ActionResult<bool>> SaveOrganisationPost(OrganisationPost OrgPost)
        {
            try
            {
                _context.OrganisationPosts.Add(OrgPost);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {

                return false;
            }
            
        }

        public ActionResult<string> OrganisationPostLike(OrganisationPostLike organisationPostLike)
        {
            var existingPost = _context.OrganisationPostLikes.FirstOrDefault(x => x.OrganisationPostID == organisationPostLike.OrganisationPostID && x.UserDataID == organisationPostLike.UserDataID);

            if (existingPost == null)
            {
                try
                {


                    _context.OrganisationPostLikes.Add(organisationPostLike);
                    _context.SaveChanges();

                    return "Like added";
                }
                catch (Exception)
                {

                    return "Wrong OrganisationPostID or UserID";
                }

            }
            else
            {
                if (organisationPostLike.LikeOrDislike == existingPost.LikeOrDislike)
                {
                    try
                    {

                        _context.OrganisationPostLikes.Remove(existingPost);
                        _context.SaveChanges();
                        return "Like removed";
                    }
                    catch (Exception)
                    {

                        return "Wrong OrganisationPostID or UserID";
                    }

                }
                else
                {
                    try
                    {

                        existingPost.LikeOrDislike *= -1;
                        _context.OrganisationPostLikes.Update(existingPost);
                        _context.SaveChanges();
                        return "Like edited";
                    }

                    catch (Exception)
                    {

                        return "Wrong OrganisationPostID or UserID";
                    }
                }
            }
        }
    }
}
