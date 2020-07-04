using Backend.DAL.Interfaces;
using Backend.Data;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class CategoriesDAL : ICategoriesDAL
    {
        private readonly DataContext _context;

        public CategoriesDAL(DataContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<IEnumerable<Category>>> GetCategories()
        {
            return await _context.Categories.ToListAsync();
        }

    }
}
