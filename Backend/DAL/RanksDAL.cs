using Backend.DAL.Interfaces;
using Backend.Data;
using Backend.Functions;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class RanksDAL : IRanksDAL
    {
        private readonly DataContext _context;

        public RanksDAL(DataContext context)
        {
            _context = context;
        }

        public ActionResult<IEnumerable<Rank>> GetRanksAsync()
        {
            var ranks = _context.Ranks.ToList();

            return ranks;
        }

        public async Task<ActionResult<string>> DeleteRank(int id)
        {
            try
            {
                var rank = await _context.Ranks.FindAsync(id);

                if (rank.UrlPath != null)
                {
                    ImageDelete imgDelete = new ImageDelete();
                    imgDelete.ImageDeleteURL(rank.UrlPath);
                }

                _context.Ranks.Remove(rank);
                await _context.SaveChangesAsync();
                return "Rank deleted";
            }
            catch (Exception)
            {
                return "Failed to delete rank with that id";
            }
        }

        public async Task<ActionResult<bool>> EditRank(Rank rank)
        {
            var rankForEdit = await _context.Ranks.FirstOrDefaultAsync(x => x.ID == rank.ID);

            if (rankForEdit == null)
            {
                return false;
            }
            else
            {
                try
                {
                    rankForEdit.MinPoints = rank.MinPoints;
                    rankForEdit.MaxPoints = rank.MaxPoints;
                    rankForEdit.Name = rank.Name;

                    if (rankForEdit.UrlPath != null)
                    {
                        ImageDelete imgDelete = new ImageDelete();
                        imgDelete.ImageDeleteURL(rankForEdit.UrlPath);
                    }
                    rankForEdit.UrlPath = rank.UrlPath;
                    

                    _context.Ranks.Update(rankForEdit);

                    _context.SaveChanges();

                    return true;
                }
                catch (Exception)
                {

                    return false;
                }

            }
        }

        public async Task<bool> SaveRank(Rank rank)
        {
            var maxPoints = _context.Ranks.Max(x => x.MaxPoints);

            if (rank.MinPoints == (maxPoints + 1) && rank.MaxPoints > rank.MinPoints)
            {
                _context.Ranks.Add(rank);
                await _context.SaveChangesAsync();
                return true;
            }
            else
                return false;

            
        }
    }
}
