using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using XeMayShop.Models;

namespace XeMayShop.Areas.Admin.Controllers
{
    public class AdminChiNhanhsController : Controller
    {
        private QuanLyXeMayEntities db = new QuanLyXeMayEntities();

        // GET: Admin/AdminChiNhanhs
        public ActionResult Index()
        {
            if (Session["Admin"] == null)
            {
                return RedirectToAction("Index", "AdminLogin");
            }
            return View(db.ChiNhanhs.ToList());
        }

        // GET: Admin/AdminChiNhanhs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiNhanh chiNhanh = db.ChiNhanhs.Find(id);
            if (chiNhanh == null)
            {
                return HttpNotFound();
            }
            return View(chiNhanh);
        }

        // GET: Admin/AdminChiNhanhs/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/AdminChiNhanhs/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(ChiNhanh chiNhanh)
        {
            try
            {
                if (ModelState.IsValid)
                {                   
                    db.sp_TaoChiNhanh(chiNhanh.TenChiNhanh, chiNhanh.DiaChi);
                    return RedirectToAction("Index");
                }
            }
            catch(Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;                
            }
            return View(chiNhanh);
        }

        // GET: Admin/AdminChiNhanhs/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiNhanh chiNhanh = db.ChiNhanhs.Find(id);
            if (chiNhanh == null)
            {
                return HttpNotFound();
            }
            return View(chiNhanh);
        }

        // POST: Admin/AdminChiNhanhs/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(ChiNhanh chiNhanh)
        {
            /*
            if (ModelState.IsValid)
            {
                db.Entry(chiNhanh).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(chiNhanh);*/

            try
            {
                db.sp_CapNhatThongTinChiNhanh(chiNhanh.MaChiNhanh, chiNhanh.TenChiNhanh, chiNhanh.DiaChi);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            return View(chiNhanh);

        }

        // GET: Admin/AdminChiNhanhs/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiNhanh chiNhanh = db.ChiNhanhs.Find(id);
            if (chiNhanh == null)
            {
                return HttpNotFound();
            }
            return View(chiNhanh);
        }

        // POST: Admin/AdminChiNhanhs/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            /*ChiNhanh chiNhanh = db.ChiNhanhs.Find(id);
            db.ChiNhanhs.Remove(chiNhanh);
            db.SaveChanges();
            return RedirectToAction("Index");*/
            try
            {
                db.sp_XoaChiNhanh(id);
                return RedirectToAction("Index");
            }
            catch(Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            ChiNhanh chiNhanh = db.ChiNhanhs.Find(id);
            return View(chiNhanh);
            

        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
