using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IRanksDAL
    {
        ActionResult<IEnumerable<Rank>> GetRanksAsync();
        public Task<ActionResult<string>> DeleteRank(int id);
        public Task<ActionResult<bool>> EditRank(Rank rank);
        public Task<bool> SaveRank(Rank rank);

    }
}
