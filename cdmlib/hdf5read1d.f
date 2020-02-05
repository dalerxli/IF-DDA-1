      !ecrit une sous matrice dont les dimensions sont definies par
      !dim(1)=nx dim(2)=nxm 
      subroutine hdf5read1d(file_id, datasetname, data0, dim0)
#ifdef USE_HDF5

         use HDF5
         implicit none
         integer(hid_t) :: file_id
         integer, dimension(4) :: dim0
         double precision , dimension(dim0(2)) :: data0

         character(LEN=100) :: datasetname
         integer(hid_t) :: dataset_id
         integer(hid_t) :: dataspace_id
         integer :: rank !nb axes
         integer(hsize_t), dimension(1) :: dims

         integer(hid_t) :: memspace_id
         integer(hsize_t), dimension(1) :: memcount, memoffset,
     &   memstride, memblock

         integer(hid_t) :: group_id
         integer :: error

         integer i, j

         dims = dim0(1)
         rank = 1

         !ouvre le dataspace du dataset
         call h5dopen_f(file_id, datasetname, dataset_id, error)

         !obtient le dataspace du dataset
         call h5dget_space_f(dataset_id, dataspace_id, error)

         dims = dim0(2)
         !cree espace memoire avec la sous matrice selon l hyperslab
         call h5screate_simple_f(rank, dims, memspace_id,error) 

         memoffset(1) = 0
         memcount(1) = dim0(1)
         memstride(1) = 1
         memblock(1) = 1
         !selectionne la sous matrice dans data0
         call h5sselect_hyperslab_f(memspace_id, H5S_SELECT_SET_F,
     &   memoffset, memcount, error, memstride, memblock)

         !ecrit le dataset
         call h5dread_f(dataset_id, H5T_NATIVE_DOUBLE, data0, dims,
     &   error, memspace_id, dataspace_id)

         !ferme le dataset
         call h5dclose_f(dataset_id, error)
         !ferme le dataspace du dataset
         call h5sclose_f(dataspace_id, error)
         !ferme le dataspace de espace memoire
         call h5sclose_f(memspace_id, error)
#endif
      end subroutine hdf5read1d
