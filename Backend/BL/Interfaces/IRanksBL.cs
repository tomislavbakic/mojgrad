using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IRanksBL
    {
        ActionResult<IEnumerable<Rank>> GetRanks();
        public Task<ActionResult<string>> DeleteRank(int id);
        public Task<ActionResult<bool>> EditRank(Rank rank);
        public Task<bool> SaveRank(Rank rank);
    }
}
