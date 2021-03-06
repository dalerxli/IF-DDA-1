      subroutine greencalculquadfft(nx,ny,nz,nx2,ny2,nz2,nxy2,nxm,nym
     $     ,nzm,nquad,tolinit,aretecube,k0,FFTTENSORxx,FFTTENSORxy
     $     ,FFTTENSORxz ,FFTTENSORyy,FFTTENSORyz,FFTTENSORzz,planb)
      implicit none
      integer nx,ny,nz,nx2,ny2,nz2,nxy2,nxm,nym,nzm,nquad
      double precision aretecube,k0,tolinit
      double complex, dimension(8*nxm*nym*nzm) :: FFTTENSORxx,
     $     FFTTENSORxy,FFTTENSORxz,FFTTENSORyy,FFTTENSORyz, FFTTENSORzz

      integer ii,jj,kk,i,j,k,indice,FFTW_BACKWARD
      double precision x0,y0,z0,xx0,yy0,zz0,RELREQ,lim
      double complex propaesplibre(3,3)
      integer*8 planb
      x0=0.d0
      y0=0.d0
      z0=0.d0
      FFTW_BACKWARD=+1
      
      do kk=1,nz2
         do jj=1,ny2
            do ii=1,nx2
               indice=ii+nx2*(jj-1)+nxy2*(kk-1)
               if (ii.eq.nx+1.or.jj.eq.ny+1.or.kk.eq.nz+1) then
                  FFTTENSORxx(indice)=0.d0
                  FFTTENSORxy(indice)=0.d0
                  FFTTENSORxz(indice)=0.d0
                  FFTTENSORyy(indice)=0.d0
                  FFTTENSORyz(indice)=0.d0
                  FFTTENSORzz(indice)=0.d0
               else
                  if (ii.gt.nx) then
                     i=(ii-1)-nx2
                  else
                     i=ii-1
                  endif
                  if (jj.gt.ny) then
                     j=(jj-1)-ny2
                  else
                     j=jj-1
                  endif
                  if (kk.gt.nz) then
                     k=(kk-1)-nz2
                  else
                     k=kk-1
                  endif
                  xx0=dble(i)*aretecube
                  yy0=dble(j)*aretecube
                  zz0=dble(k)*aretecube
c     integration de l'espace libre
                  if (nquad.ne.0.and.i*i+j*j+k*k.le.nquad*nquad) then
                     RELREQ=tolinit
                     lim=1.d0
                     call propaespacelibreintsim(x0,y0,z0,xx0,yy0,zz0
     $                    ,k0,aretecube,lim,RELREQ,propaesplibre)
                    
                  else
                     call propa_espace_libre(x0,y0,z0,xx0,yy0,zz0,k0
     $                    ,propaesplibre)
                  endif                    
                  

                  FFTTENSORxx(indice)=propaesplibre(1,1)
                  FFTTENSORxy(indice)=propaesplibre(1,2)
                  FFTTENSORxz(indice)=propaesplibre(1,3)
                  FFTTENSORyy(indice)=propaesplibre(2,2)
                  FFTTENSORyz(indice)=propaesplibre(2,3)
                  FFTTENSORzz(indice)=propaesplibre(3,3)
               endif
            enddo
         enddo
      enddo

      
      write(*,*) 'End computation of the Green function'
c     compute the FFT of the Green function
#ifdef USE_FFTW
      call dfftw_execute_dft(planb,FFTTENSORxx,FFTTENSORxx)
      call dfftw_execute_dft(planb,FFTTENSORxy,FFTTENSORxy) 
      call dfftw_execute_dft(planb,FFTTENSORxz,FFTTENSORxz)
      call dfftw_execute_dft(planb,FFTTENSORyy,FFTTENSORyy)
      call dfftw_execute_dft(planb,FFTTENSORyz,FFTTENSORyz)
      call dfftw_execute_dft(planb,FFTTENSORzz,FFTTENSORzz)
#else
  
!$OMP PARALLEL DEFAULT(SHARED)
!$OMP SECTIONS 
!$OMP SECTION   
      call fftsingletonz3d(FFTTENSORxx,NX2,NY2,NZ2,FFTW_BACKWARD)
!$OMP SECTION   
      call fftsingletonz3d(FFTTENSORxy,NX2,NY2,NZ2,FFTW_BACKWARD)
!$OMP SECTION   
      call fftsingletonz3d(FFTTENSORxz,NX2,NY2,NZ2,FFTW_BACKWARD)
!$OMP SECTION   
      call fftsingletonz3d(FFTTENSORyy,NX2,NY2,NZ2,FFTW_BACKWARD)
!$OMP SECTION   
      call fftsingletonz3d(FFTTENSORyz,NX2,NY2,NZ2,FFTW_BACKWARD)
!$OMP SECTION   
      call fftsingletonz3d(FFTTENSORzz,NX2,NY2,NZ2,FFTW_BACKWARD)
!$OMP END SECTIONS
!$OMP END PARALLEL  
    
#endif


      end
