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
    
    public partial class DongXe
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DongXe()
        {
            this.Xes = new HashSet<Xe>();
        }
    
        public int MaDongXe { get; set; }
        public Nullable<int> MaLoaiXe { get; set; }
        public string TenDongXe { get; set; }
        public Nullable<int> SoLuongHienCo { get; set; }
    
        public virtual LoaiXe LoaiXe { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Xe> Xes { get; set; }
    }
}
