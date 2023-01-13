//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace XeMayShop.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class PhieuXuat
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public PhieuXuat()
        {
            this.PhieuBaoHanhs = new HashSet<PhieuBaoHanh>();
        }
    
        public int MaPhieuXuat { get; set; }
        public Nullable<int> MaNhanVien { get; set; }
        public Nullable<int> MaKhachHang { get; set; }
        public Nullable<int> MaChiNhanh { get; set; }
        public Nullable<int> MaXe { get; set; }
        public string MauXe { get; set; }
        public Nullable<System.DateTime> NgayXuat { get; set; }
        public Nullable<int> ThanhTienXuat { get; set; }
        public string GhiChu { get; set; }
    
        public virtual ChiNhanh ChiNhanh { get; set; }
        public virtual KhachHang KhachHang { get; set; }
        public virtual NhanVien NhanVien { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PhieuBaoHanh> PhieuBaoHanhs { get; set; }
        public virtual Xe Xe { get; set; }
    }
}