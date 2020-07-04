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
    public class OrganisationsDAL : IOrganisationsDAL
    {
        private readonly DataContext _context;

        public OrganisationsDAL(DataContext context)
        {
            _context = context;
        }
        public Organisation AuthenticateOrganisation(Login login)
        {
            var existingUser = _context.Organisations.
                Where(k => k.Email.Equals(login.Email)
                    && k.Password.Equals(login.Password)).FirstOrDefault();
            return existingUser;
        }

        public List<Organisation> GetVerifiedOrganisations()
        {
            return _context.Organisations.Where(x => x.Verification == 1).ToList();
        }

        public List<OrganisationInfo> GetVerifiedOrganisations(int ver)
        {
            var orgs =  _context.Organisations.Where(x => x.Verification == ver).ToList();

            List<OrganisationInfo> OrgsList = new List<OrganisationInfo>();

            foreach (var item in orgs)
            {
                OrganisationInfo oi = new OrganisationInfo();

                oi.ID = item.ID;
                oi.Name = item.Name;
                oi.Email = item.Email;
                oi.PhoneNumber = item.PhoneNumber;
                oi.Activity = item.Activity;
                oi.Location = item.Location;
                oi.Photo = item.ImagePath;
                oi.Verification = item.Verification;

                OrgsList.Add(oi);

            }

            return OrgsList;
        }

        public List<OrganisationInfo> GetAllOrganisations()
        {
            var orgs = _context.Organisations.ToList();

            List<OrganisationInfo> OrgsList = new List<OrganisationInfo>();

            foreach (var item in orgs)
            {
                OrganisationInfo oi = new OrganisationInfo();

                oi.ID = item.ID;
                oi.Name = item.Name;
                oi.Email = item.Email;
                oi.PhoneNumber = item.PhoneNumber;
                oi.Activity = item.Activity;
                oi.Location = item.Location;
                oi.Photo = item.ImagePath;
                oi.Verification = item.Verification;

                OrgsList.Add(oi);

            }

            return OrgsList;
        }

        public Organisation VerifyOrganisations(int id)
        {
            var org = _context.Organisations.FirstOrDefault(x => x.ID == id);
            if (org == null) return null;
            if(org.Verification == 0)
            {
                org.Verification = 1;
                _context.Organisations.Update(org);
                _context.SaveChanges();
                return org;
            }
            else
            {
                org.Verification = 0;
                _context.Organisations.Update(org);
                _context.SaveChanges();
                return null;
            }
        }

        public  ActionResult<OrganisationInfo> GetOrganisationAsync(int id)
        {
            OrganisationInfo oi = new OrganisationInfo();
            try
            {
                var organisation = _context.Organisations.Find(id);

                

                oi.ID = organisation.ID;
                oi.Name = organisation.Name;
                oi.Email = organisation.Email;
                oi.PhoneNumber = organisation.PhoneNumber;
                oi.Activity = organisation.Activity;
                oi.Location = organisation.Location;
                oi.Photo = organisation.ImagePath;
                oi.Verification = organisation.Verification;

                return oi;
            }
            catch (Exception)
            {

                return oi;
            }
            
        }

        public async Task<ActionResult<bool>> DeleteOrganisation(OrganisationDelete organisationDelete)
        {
            var org = await _context.Organisations.FirstOrDefaultAsync(x => x.ID == organisationDelete.ID);
            if (org == null)
                return false;

            if (org.Password != organisationDelete.Password)
                return false;

            try
            {
                if (org.ImagePath != null)
                {
                    ImageDelete imgDelete = new ImageDelete();
                    imgDelete.ImageDeleteURL(org.ImagePath);
                }

                _context.Organisations.Remove(org);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {

                return false;
            }
        }

        public async Task<bool> ChangeOrgData(Organisation org)
        {
            try
            {
                var orgToChange = await _context.Organisations.FirstOrDefaultAsync(x => x.ID == org.ID);

                if (org.Name != null)
                    orgToChange.Name = org.Name;
                if (org.Location != null)
                    orgToChange.Location = org.Location;
                if (org.Email != null)
                    orgToChange.Email = org.Email;
                if (org.ImagePath != null)
                {
                    ImageDelete imgDelete = new ImageDelete();
                    imgDelete.ImageDeleteURL(orgToChange.ImagePath);
                    orgToChange.ImagePath = org.ImagePath;

                }
                    

                _context.Organisations.Update(orgToChange);

                _context.SaveChanges();

                return true;
            }
            catch (Exception)
            {

                return false;
            }
        }

        public async Task<bool> TryToChangePassword(ChangePassword changePassword)
        {
            var org = await _context.Organisations.FirstOrDefaultAsync(x => x.ID == changePassword.ID);

            if (org.Password == changePassword.OldPassword)
            {
                org.Password = changePassword.NewPassword;

                _context.Organisations.Update(org);

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
