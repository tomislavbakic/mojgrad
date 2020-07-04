using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class RanksUI : IRanksUI
    {
        private readonly IRanksBL _IRanksBL;

        public RanksUI(IRanksBL IRanksBL)
        {
            _IRanksBL = IRanksBL;
        }
        public ActionResult<IEnumerable<Rank>> GetRanks()
        {
            return _IRanksBL.GetRanks();
        }
        public Task<ActionResult<string>> DeleteRank(int id)
        {
            return _IRanksBL.DeleteRank(id);
        }
        public Task<ActionResult<bool>> EditRank(Rank rank)
        {
            return _IRanksBL.EditRank(rank);
        }
        public Task<bool> SaveRank(Rank rank)
        {
            return _IRanksBL.SaveRank(rank);
        }
    }
}
