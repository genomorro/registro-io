<?php

namespace App\Controller;

use App\Form\SearchTagType;
use App\Form\SearchType;
use App\Repository\AttendanceRepository;
use App\Repository\PatientRepository;
use App\Entity\Patient;
use App\Entity\Visitor;
use App\Repository\SearchRepository;
use App\Repository\VisitorRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Contracts\Translation\TranslatorInterface;

#[Route('/search')]
class SearchController extends AbstractController
{
    #[Route('/checkOut', name: 'app_search_check_list_index')]
    public function checkOutList(SearchRepository $searchRepository): Response
    {
        // $this->denyAccessUnlessGranted('ROLE_USER');

        $patients = $searchRepository->findCurrentPatients();
        $visitors = $searchRepository->findCurrentVisitors();

        return $this->render('search/check_out_list.html.twig', [
            'patients' => $patients,
            'visitors' => $visitors,
        ]);
    }

    #[Route('/', name: 'app_search_index')]
    public function index(Request $request, PatientRepository $patientRepository, SearchRepository $searchRepository, TranslatorInterface $translator): Response
    {
	// $this->denyAccessUnlessGranted('ROLE_USER');

	$formFile = $this->createForm(SearchType::class);
        $formFile->handleRequest($request);
	$flashFile = $translator->trans('Patient not found');

        if ($formFile->isSubmitted() && $formFile->isValid()) {
            $data = $formFile->getData();
            $file = $data['file'];

            $patient = $patientRepository->findOneByFile($file);

            if ($patient) {
                return $this->redirectToRoute('app_patient_show', ['id' => $patient->getId()]);
            }

            $this->addFlash('error', $flashFile);
	    return $this->redirectToRoute('app_search_index');
        }

	
        $formTag = $this->createForm(SearchTagType::class);
        $formTag->handleRequest($request);
	$flashTag = $translator->trans('Patient nor Visitor not found for the given tag.');

        if ($formTag->isSubmitted() && $formTag->isValid()) {
            $data = $formTag->getData();
            $tag = (int)$data['tag'];

            $patients = $searchRepository->findCurrentPatientsByTag($tag);
            $visitors = $searchRepository->findCurrentVisitorsByTag($tag);

            if ($patients or $visitors) {
		return $this->redirectToRoute('app_search_check_index', ['tag' => $tag]);
            }

            $this->addFlash('error', $flashTag);
            return $this->redirectToRoute('app_search_index');
        }

	
        return $this->render('search/index.html.twig', [
	    'formFile' => $formFile->createView(),
            'formTag' => $formTag->createView(),
	    'title' => "Search Check Out by Tag",
        ]);
    }
    
    #[Route('/tag/{tag}/check_out', name: 'app_search_check_index')]
    public function checkOut(string $tag, SearchRepository $searchRepository): Response
    {
        // $this->denyAccessUnlessGranted('ROLE_USER');

        $patients = $searchRepository->findCurrentPatientsByTag($tag);
        $visitors = $searchRepository->findCurrentVisitorsByTag($tag);

        return $this->render('search/check_out.html.twig', [
            'patients' => $patients,
            'visitors' => $visitors,
            'tag' => $tag,
        ]);
    }

    #[Route('/{id}/patient-check-out-list', name: 'app_patient_check_out_list', methods: ['POST'])]
    public function patientCheckOutList(Request $request, Patient $patient, AttendanceRepository $attendanceRepository, EntityManagerInterface $entityManager): Response
    {
        // $this->denyAccessUnlessGranted('ROLE_USER');

        $attendance = $attendanceRepository->findOneByPatientAndDate($patient, new \DateTime());
        if ($attendance) {
            $attendance->setCheckOutAt(new \DateTimeImmutable());
            $entityManager->flush();
        }

        return $this->redirectToRoute('app_search_check_list_index');
    }

    #[Route('/{id}/visitor-check-out-list', name: 'app_visitor_check_out_list', methods: ['POST'])]
    public function visitorCheckOutList(Request $request, Visitor $visitor, EntityManagerInterface $entityManager): Response
    {
        // $this->denyAccessUnlessGranted('ROLE_USER');

        $visitor->setCheckOutAt(new \DateTimeImmutable());
        $entityManager->flush();

        return $this->redirectToRoute('app_search_check_list_index');
    }
}
