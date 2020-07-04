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
using Microsoft.AspNetCore.Authorization;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RanksController : ControllerBase
    {
        private readonly DataContext _context;
        private readonly IRanksUI _IRanksUI;

        public RanksController(DataContext context, IRanksUI IRanksUI)
        {
            _context = context;
            _IRanksUI = IRanksUI;
        }

        // GET: api/Ranks
        [Authorize]
        [HttpGet]
        public  ActionResult<IEnumerable<Rank>> GetRanks()
        {
            return  _IRanksUI.GetRanks();
            
        }

        [Authorize]
        [HttpPut]
        public async Task<ActionResult<bool>> EditRank(Rank rank)
        {
            return await _IRanksUI.EditRank(rank);
        }

        [Authorize]
        [HttpPost]
        public async Task<bool> PostRank(Rank rank)
        {
           return await _IRanksUI.SaveRank(rank);
        }

        // DELETE: api/Ranks/5
        [Authorize]
        [HttpDelete("{id}")]
        public async Task<ActionResult<string>> DeleteRank(int id)
        {
            return await _IRanksUI.DeleteRank(id);
        }

    }
}
