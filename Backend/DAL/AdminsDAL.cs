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
    public class AdminsDAL : IAdminsDAL
    {
        private readonly DataContext _context;

        public AdminsDAL(DataContext context)
        {
            _context = context;
        }

        public bool AddNewAdmin(Admin admin)
        {
            Admin check =  _context.Admins.Where(x => x.Username.Equals(admin.Username)).FirstOrDefault();

            if (check == null)
            {
                admin.Head = 0;
                _context.Admins.Add(admin);
                _context.SaveChanges();
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool DeleteAdmin(string name)
        {
            var admin = _context.Admins.FirstOrDefault(x => x.Username.ToLower() == name.ToLower());

            if (admin != null)
            {
                _context.Admins.Remove(admin);
                _context.SaveChanges();
                return true;
            }
            else
            {
                return false;
            }
        }

        public Admin AuthenticateUser(Admin admin)
        {
            var existingUser = _context.Admins.
                Where(k => k.Username.Equals(admin.Username)
                    && k.Password.Equals(admin.Password)).FirstOrDefault();
            return existingUser;
        }

        public async Task<ActionResult<bool>> DeleteOrganisation(int id)
        {
            var org = await _context.Organisations.FirstOrDefaultAsync(x => x.ID == id);
            if (org == null)
                return false;

            try
            {
                if (org.ImagePath != null)
                {
                    ImageDelete imgDelete = new ImageDelete();
                    imgDelete.ImageDeleteURL(org.ImagePath);
                }

                _context.Organisations.Remove(org);
                var solForDelete = _context.PostSolutions.Where(x => x.UserType == 2 && x.UserID == org.ID);
                foreach (var item in solForDelete)
                {
                    _context.PostSolutions.Remove(item);
                }
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public async Task<ActionResult<bool>> DeleteUser(int id)
        {
            var user = await _context.UserDatas.FirstOrDefaultAsync(x => x.ID == id);
            if (user == null)
                return false;

            try
            {
                if (user.Photo != null)
                {
                    ImageDelete imgDelete = new ImageDelete();
                    imgDelete.ImageDeleteURL(user.Photo);
                }
                _context.UserDatas.Remove(user);

                var solForDelete = _context.PostSolutions.Where(x => x.UserType == 1 && x.UserID == user.ID);
                foreach (var item in solForDelete)
                {
                    _context.PostSolutions.Remove(item);
                }
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception e)
            {

                return false;
            }
        }

        public List<AdminInfo> GetAdminNames()
        {
            List<AdminInfo> AdminInfos = new List<AdminInfo>();

            var admins = _context.Admins;

            foreach (var item in admins)
            {
                AdminInfo adminInfo = new AdminInfo();
                adminInfo.Username = item.Username;
                adminInfo.Head = item.Head;

                AdminInfos.Add(adminInfo);
            }

            return AdminInfos;
        }

        public StatisticsInfo GetStatistics()
        {
            StatisticsInfo si = new StatisticsInfo();
            double averageGrade;
            var posts = _context.Posts;

            si.NumberOfMobileUsers = _context.UserDatas.Count();
            si.NumberOfOrganisations = _context.Organisations.Count();
            si.NumberOfUsers = si.NumberOfMobileUsers + si.NumberOfOrganisations;
            si.NumberOfPosts = _context.Posts.Count() + _context.OrganisationPosts.Count();
            if(_context.Ratings.Count() == 0)
            {
                averageGrade = 0;
            }
            else
            {
                averageGrade = _context.Ratings.Average(x => x.Grade);
            }
            si.AverageGrade = averageGrade.ToString($"F{1}");

            return si;
        }

        public GenderInfo GenderStats()
        {
            GenderInfo gi = new GenderInfo();

            var users = _context.UserDatas;

            gi.NumberOfFemale = users.Where(x => x.Gender == "ženski").Count();
            gi.NumberOfMale = users.Where(x => x.Gender == "muški").Count();

            var sum = gi.NumberOfMale + gi.NumberOfFemale;

            gi.PercentOfMale = (((gi.NumberOfMale * 1.0) / (sum * 1.0)) * 100).ToString($"F{1}");
            gi.PercentOfFemale = (((gi.NumberOfFemale * 1.0) / (sum * 1.0)) * 100).ToString($"F{1}");

            gi.AverageAge = users.Average(x => x.Age).ToString($"F{1}");

            return gi;


        }

        public bool IsHeadAdmin(int adminID)
        {
            var admin = _context.Admins.FirstOrDefault(x => x.ID == adminID);

            if (admin != null)
            {
                _context.Admins.Remove(admin);
                _context.SaveChanges();
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
