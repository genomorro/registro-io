<?php

namespace App\Controller;

use App\Form\SearchByFileType;
use App\Repository\PatientRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class SearchByFileController extends AbstractController
{
    #[Route('/search-by-file', name: 'app_search_by_file', methods: ['GET', 'POST'])]
    public function search(Request $request, PatientRepository $patientRepository): Response
    {
        $form = $this->createForm(SearchByFileType::class);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $file = $form->get('file')->getData();
            $patients = $patientRepository->findByFile($file);

            if (count($patients) === 1) {
                return $this->redirectToRoute('app_patient_show', ['id' => $patients[0]->getId()]);
            }

            return $this->render('search_by_file/index.html.twig', [
                'form' => $form->createView(),
                'patients' => $patients,
            ]);
        }

        return $this->render('search_by_file/index.html.twig', [
            'form' => $form->createView(),
            'patients' => [],
        ]);
    }
}
