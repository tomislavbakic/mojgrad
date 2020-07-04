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
    public class CategoriesUI : ICategoriesUI
    {
        private readonly ICategoriesBL _ICategoriesBL;

        public CategoriesUI(ICategoriesBL ICategoriesBL)
        {
            _ICategoriesBL = ICategoriesBL;
        }

        public Task<ActionResult<IEnumerable<Category>>> GetCategories()
        {
            return _ICategoriesBL.GetCategories();
        }
    }
}
