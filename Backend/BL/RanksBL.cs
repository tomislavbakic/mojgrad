using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class RanksBL : IRanksBL
    {
        private readonly IRanksDAL _IRanksDAL;

        public RanksBL(IRanksDAL IRanksDAL)
        {
            _IRanksDAL = IRanksDAL;
        }
        public ActionResult<IEnumerable<Rank>> GetRanks()
        {
            return _IRanksDAL.GetRanksAsync();
        }

        public Task<ActionResult<string>> DeleteRank(int id)
        {
            return _IRanksDAL.DeleteRank(id);
        }
        public Task<ActionResult<bool>> EditRank(Rank rank)
        {
            return _IRanksDAL.EditRank(rank);
        }
        public Task<bool> SaveRank(Rank rank)
        {
            return _IRanksDAL.SaveRank(rank);
        }
    }
}
