using Backend.DAL.Interfaces;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public class CategoriesBL : ICategoriesBL
    {
        private readonly ICategoriesDAL _ICategoriesDAL;

        public CategoriesBL(ICategoriesDAL ICategoriesDAL)
        {
            _ICategoriesDAL = ICategoriesDAL;
        }

        public Task<ActionResult<IEnumerable<Category>>> GetCategories()
        {
            return _ICategoriesDAL.GetCategories();
        }
    }
}
