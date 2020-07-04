using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using Backend.UI.Interfaces;
using Backend.Models.ViewModels;
using MimeKit;
using MailKit.Net.Smtp;
using Microsoft.AspNetCore.Authorization;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrganisationsController : ControllerBase
    {
        private readonly DataContext _context;
        private readonly IOrganisationsUI _IOrganisationsUI;

        public OrganisationsController(DataContext context, IOrganisationsUI IOrganisationsUI)
        {
            _context = context;
            _IOrganisationsUI = IOrganisationsUI;
        }

        [Route("login")]
        [HttpPost]
        public IActionResult Login(Login login)
        {
            IActionResult response = Unauthorized();

            var organisation = _IOrganisationsUI.AuthenticateOrganisation(login);

            //var user = AuthenticateUser(login);

            if (organisation != null)
            {
                string tokenStr = _IOrganisationsUI.GenerateJSONWebToken(organisation);
                response = Ok(new { token = tokenStr });
            }
            return response;
        }



        //Check for email
        [Route("email")]
        [HttpPost]
        public async Task<ActionResult<bool>> ProveriEmail(UserEmail email)
        {
            var korisnici = await _context.Organisations.ToListAsync();
            var korisnik = korisnici.Where(k => k.Email.Equals(email.Email)).FirstOrDefault();
            Console.WriteLine("sdasdasd" + korisnici.Count);
            if (korisnik == null)
                return false;
            return true;
        }


        // GET: api/Organisations
        [Authorize]
        [HttpGet]
        public List<OrganisationInfo> GetOrganisation()
        {
            return _IOrganisationsUI.GetAllOrganisations();
        }

        [Authorize]
        [Route("verified")]
        [HttpGet]
        public List<OrganisationInfo> GetVerifiedOrganisations()
        {
            return _IOrganisationsUI.GetVerifiedOrganisations();
        }

        [Authorize]
        [Route("unverified")]
        [HttpGet]
        public List<OrganisationInfo> GetUnverifiedOrganisations()
        {
            return _IOrganisationsUI.GetUnverifiedOrganisations();
        }

        [Authorize]
        [Route("verify/{id}")]
        [HttpPost]
        public string VerifyOrganisations(int id)
        {
            Organisation org = _IOrganisationsUI.VerifyOrganisations(id);
            if(org != null)
            {
                var message = new MimeMessage();
                message.From.Add(new MailboxAddress("Moj grad", "mojgrad.srb@gmail.com"));
                message.To.Add(new MailboxAddress("Moj grad", org.Email));
                message.Subject = "Moj grad";
                message.Body = new TextPart("plain")
                {
                    Text = "Vaš zahtev za verifikaciju je prihvaćen.\nOd sada možete da pišete svoje objave i da učestvujete u podizanju ekološke svesti i rešavanju problema u svom gradu.\nMoj grad."
                   
                };
                using (var client = new SmtpClient())
                {
                    client.Connect("smtp.gmail.com", 587, false);
                    client.Authenticate("mojgrad.srb@gmail.com", "mojgrad123");
                    client.Send(message);
                    client.Disconnect(true);

                }
                return "Verifikovano";
            }
            return "Nije verifikovanio";
        }



        //ODRADITI
        [Authorize]
        [HttpGet("{id}")]
        public ActionResult<OrganisationInfo> GetOrganisation(int id)
        {
            return _IOrganisationsUI.GetOrganisation(id);
            
        }

        [Authorize]
        [Route("deleteOrg")]
        [HttpPost]
        public async Task<ActionResult<bool>> DeleteOrganisation(OrganisationDelete organisationDelete)
        {
            return await _IOrganisationsUI.DeleteOrganisation(organisationDelete);
        }

        [Authorize]
        [Route("changeOrgPass")]
        [HttpPut]
        public Task<bool> ChangeOrganisationPassword(ChangePassword changePassword)
        {
            return _IOrganisationsUI.TryToChangePassword(changePassword);
        }

        [Authorize]
        [Route("changeOrgData")]
        [HttpPut]
        public Task<bool> ChangeOrgData(Organisation org)
        {
            return _IOrganisationsUI.ChangeOrgData(org);
        }


        // POST: api/Organisations
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for
        // more details see https://aka.ms/RazorPagesCRUD.
        
        [HttpPost]
        public async Task<ActionResult<Organisation>> PostOrganisation(Organisation organisation)
        {
            organisation.ImagePath = "Upload//Organisations//default.png";
            _context.Organisations.Add(organisation);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetOrganisation", new { id = organisation.ID }, organisation);
        }

    }
}
